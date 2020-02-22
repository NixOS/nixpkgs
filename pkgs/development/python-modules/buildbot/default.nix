{ stdenv, lib, buildPythonPackage, fetchPypi, fetchpatch, makeWrapper, isPy3k,
  python, twisted, jinja2, zope_interface, future, sqlalchemy,
  sqlalchemy_migrate, dateutil, txaio, autobahn, pyjwt, pyyaml, treq,
  txrequests, pyjade, boto3, moto, mock, python-lz4, setuptoolsTrial,
  isort, pylint, flake8, buildbot-worker, buildbot-pkg, buildbot-plugins,
  parameterized, git, openssh, glibcLocales }:

let
  withPlugins = plugins: buildPythonPackage {
    name = "${package.name}-with-plugins";
    phases = [ "installPhase" "fixupPhase" ];
    buildInputs = [ makeWrapper ];
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
    version = "2.6.0";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1l3ajhy68jddbgbizaa5hq65lgqkll6389hss4p2j36cbxbn7hiv";
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
    ]
      # tls
      ++ twisted.extras.tls;

    checkInputs = [
      treq
      txrequests
      pyjade
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
    };

    meta = with lib; {
      homepage = "https://buildbot.net/";
      description = "Buildbot is an open-source continuous integration framework for automating software build, test, and release processes";
      maintainers = with maintainers; [ nand0p ryansydnor lopsided98 ];
      license = licenses.gpl2;
    };
  };
in package
