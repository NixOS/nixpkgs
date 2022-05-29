{ stdenv, lib, buildPythonPackage, fetchPypi, makeWrapper, isPy3k
, python, twisted, jinja2, msgpack, zope_interface, sqlalchemy, alembic
, python-dateutil, txaio, autobahn, pyjwt, pyyaml, treq, txrequests, pypugjs
, boto3, moto, mock, lz4, setuptoolsTrial, isort, pylint, flake8
, buildbot-worker, buildbot-pkg, buildbot-plugins, parameterized, git, openssh
, glibcLocales
, nixosTests
}:

let
  withPlugins = plugins: buildPythonPackage {
    pname = "${package.pname}-with-plugins";
    inherit (package) version;

    dontUnpack = true;
    dontBuild = true;
    doCheck = false;

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
    version = "3.5.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-woGHdCan5qTp00toNkWa821EgVQMrPK+OWXoqFcgIDQ=";
    };

    propagatedBuildInputs = [
      # core
      twisted
      jinja2
      msgpack
      zope_interface
      sqlalchemy
      alembic
      python-dateutil
      txaio
      autobahn
      pyjwt
      pyyaml
    ]
      # tls
      ++ twisted.optional-dependencies.tls;

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

      # remove testfile which is missing configuration file from sdist
      rm buildbot/test/integration/test_graphql.py
    '';

    disabled = !isPy3k;

    passthru = {
      inherit withPlugins;
      tests.buildbot = nixosTests.buildbot;
      updateScript = ./update.sh;
    };

    meta = with lib; {
      broken = stdenv.isDarwin;
      homepage = "https://buildbot.net/";
      description = "An open-source continuous integration framework for automating software build, test, and release processes";
      maintainers = with maintainers; [ ryansydnor lopsided98 ];
      license = licenses.gpl2;
    };
  };
in package
