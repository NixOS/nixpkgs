{ stdenv, lib, buildPythonPackage, /*fetchPypi,*/ fetchFromGitHub, makeWrapper, isPy3k,
  python, twisted, jinja2, zope_interface, future, sqlalchemy,
  sqlalchemy_migrate, dateutil, txaio, autobahn, pyjwt, pyyaml, treq,
  txrequests, txgithub, pyjade, boto3, moto, mock, python-lz4, setuptoolsTrial,
  isort, pylint, flake8, buildbot-worker, buildbot-pkg, parameterized,
  glibcLocales }:

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
    version = "2.1.0";

    /*src = fetchPypi {
      inherit pname version;
      sha256 = "1745hj9s0c0fcdjv6w05bma76xqg1fv42v0dslmi4d8yz9phf37w";
    };*/
    # Temporarily use GitHub source because PyPi archive is missing some files
    # needed for the tests to pass. This has been fixed upstream.
    # See: https://github.com/buildbot/buildbot/commit/30f5927cf9a80f98ed909241a149469dec3ce68d
    src = fetchFromGitHub {
      owner = "buildbot";
      repo = "buildbot";
      rev = "v${version}";
      sha256 = "022ybhdvp0hp2z0cwgx7n41jyh56bpxj3fwm4z7ppzj1qhm7lb65";
    } + "/master";

    propagatedBuildInputs = [
      # core
      twisted
      jinja2
      zope_interface
      future
      sqlalchemy
      sqlalchemy_migrate
      dateutil
      txaio
      autobahn
      pyjwt
      pyyaml

      # tls
      twisted.extras.tls
    ];

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
      parameterized
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
      homepage = http://buildbot.net/;
      description = "Buildbot is an open-source continuous integration framework for automating software build, test, and release processes";
      maintainers = with maintainers; [ nand0p ryansydnor ];
      license = licenses.gpl2;
    };
  };
in package
