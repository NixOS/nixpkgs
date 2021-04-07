{ stdenv, lib, buildPythonPackage, fetchPypi, makeWrapper, isPy3k,
  python, twisted, jinja2, zope_interface, sqlalchemy,
  sqlalchemy_migrate, dateutil, txaio, autobahn, pyjwt, pyyaml, unidiff, treq,
  txrequests, pypugjs, boto3, moto, mock, python-lz4, setuptoolsTrial,
  isort, pylint, flake8, buildbot-worker, buildbot-pkg, buildbot-plugins,
  parameterized, git, openssh, glibcLocales, ldap3, nixosTests }:

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
    version = "3.1.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1b9m9l8bz2slkrq0l5z8zd8pd0js5w4k7dam8bdp00kv3aln4si9";
    };

    propagatedBuildInputs = [
      # core
      twisted
      jinja2
      zope_interface
      sqlalchemy
      sqlalchemy_migrate
      dateutil
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
      python-lz4
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
    };

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "An open-source continuous integration framework for automating software build, test, and release processes";
      maintainers = with maintainers; [ nand0p ryansydnor lopsided98 ];
      license = licenses.gpl2;
    };
  };
in package
