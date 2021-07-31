{ stdenv, lib, buildPythonPackage, fetchPypi, fetchpatch, makeWrapper, isPy3k
, python, twisted, jinja2, zope_interface, sqlalchemy
, sqlalchemy_migrate, python-dateutil, txaio, autobahn, pyjwt, pyyaml, unidiff, treq
, txrequests, pypugjs, boto3, moto, mock, lz4, setuptoolsTrial
, isort, pylint, flake8, buildbot-worker, buildbot-pkg, buildbot-plugins
, parameterized, git, openssh, glibcLocales, ldap3, nixosTests
}:

let
  withPlugins = plugins: buildPythonPackage {
    name = "${package.name}-with-plugins";
    phases = [ "installPhase" "fixupPhase" ];
    nativeBuildInputs = [ makeWrapper ];
    propagatedBuildInputs = plugins ++ package.propagatedBuildInputs;

    installPhase = ''
      makeWrapper ${package}/bin/buildbot $out/bin/buildbot \
        --prefix PYTHONPATH : "${package}/${python.sitePackages}:$PYTHONPATH"
      ln -sfv ${package}/lib $out/lib
    '';

    passthru = package.passthru // {
      withPlugins = morePlugins: withPlugins (morePlugins ++ plugins);
    };
  };

  package = buildPythonPackage rec {
    pname = "buildbot";
    version = "3.2.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-Ji/1anphYaGoP0kaOpArKDKPe9YUFTU1Zd9O4g6V9OA=";
    };

    propagatedBuildInputs = [
      # core
      twisted
      jinja2
      zope_interface
      sqlalchemy
      sqlalchemy_migrate
      python-dateutil
      txaio
      autobahn
      pyjwt
      pyyaml
      unidiff
    ]
      # tls
      ++ twisted.extras.tls;

    checkInputs = [
      treq
      txrequests
      pypugjs
      boto3
      moto
      mock
      lz4
      setuptoolsTrial
      isort
      pylint
      flake8
      buildbot-worker
      buildbot-pkg
      buildbot-plugins.www
      parameterized
      git
      openssh
      glibcLocales
      # optional dependency that was accidentally made required for tests
      # https://github.com/buildbot/buildbot/pull/5857
      ldap3
    ];

    patches = [
      # This patch disables the test that tries to read /etc/os-release which
      # is not accessible in sandboxed builds.
      ./skip_test_linux_distro.patch
      # Fix compatibility with SQLAlchemy 1.4
      (fetchpatch {
        url = "https://github.com/buildbot/buildbot/pull/6156.patch";
        sha256 = "10pg3wcdy85vymn6hprm7rh68zkz818m2vy6v4s2hi2l189wh5my";
        stripLen = 1;
        excludes = [
          ".bbtravis.yml"
          "buildbot/test/unit/db/test_enginestrategy.py"
          "buildbot/test/unit/db_migrate/test_versions_045_worker_transition.py"
          "requirements-ci.txt"
          "requirements-cidb.txt"
        ];
      })
    ];

    postPatch = ''
      substituteInPlace buildbot/scripts/logwatcher.py --replace '/usr/bin/tail' "$(type -P tail)"
    '';

    # TimeoutErrors on slow machines -> aarch64
    doCheck = !stdenv.isAarch64;

    preCheck = ''
      export LC_ALL="en_US.UTF-8"
      export PATH="$out/bin:$PATH"
    '';

    disabled = !isPy3k;

    passthru = {
      inherit withPlugins;
      tests.buildbot = nixosTests.buildbot;
      updateScript = ./update.sh;
    };

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "An open-source continuous integration framework for automating software build, test, and release processes";
      maintainers = with maintainers; [ ryansydnor lopsided98 ];
      license = licenses.gpl2;
    };
  };
in package
