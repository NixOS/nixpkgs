{ stdenv, lib, buildPythonPackage, fetchPypi, makeWrapper, isPy3k,
  python, twisted, jinja2, zope_interface, future, sqlalchemy,
  sqlalchemy_migrate, dateutil, txaio, autobahn, pyjwt, pyyaml, treq,
  txrequests, txgithub, pyjade, boto3, moto, mock, python-lz4, setuptoolsTrial,
  isort, pylint, flake8, buildbot-worker, buildbot-pkg, glibcLocales }:

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
    version = "1.8.1";

    src = fetchPypi {
      inherit pname version;
      sha256 = "1zadmyrlk7p9h1akmbzwa7p90s7jwsxvdx4xn9i54dnda450m3a7";
    };

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
