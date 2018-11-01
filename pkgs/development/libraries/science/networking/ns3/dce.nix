# some dependencies need to be patched
# http://code.nsnam.org/bake/file/c502b48053dc/bakeconf.xml
{ stdenv, fetchFromGitHub, autoreconfHook, libtool, intltool, pkgconfig
, ns-3, gcc
, castxml ? null
# hidden dependency of waf
, ncurses
, python
, lib
, fetchurl
, withManual ? false
, withQuagga ? false
, withExamples ? false, openssl ? null, ccnd ? null, iperf2 ? null
# shall we generate bindings
, pythonSupport ? false
, ...
}:

let
  dce-version = "1.10";
  modules = [ "core" "network" "internet" "point-to-point" "fd-net-device"
  "point-to-point-layout" "netanim" "tap-bridge" "mobility" "flow-monitor"]
  ++ lib.optionals withQuagga [ "internet-apps" ]
  ;

  ns3forDce = ns-3.override( { inherit modules python; });
  pythonEnv = python.withPackages(ps:
    stdenv.lib.optional withManual ps.sphinx
    ++ lib.optionals pythonSupport (with ps;[ pybindgen pygccxml ])
  );

  dce = stdenv.mkDerivation rec {
    name    = "${pname}-${version}";
    pname   = "direct-code-execution";
    version = dce-version;

    outputs = [ "out" ] ++ lib.optional pythonSupport "py";

    # with other modules
    srcs = [
      /home/teto/dce
      # (fetchFromGitHub {
      #   owner  = "direct-code-execution";
      #   repo   = "ns-3-dce";
      #   rev    = "dce-${version}";
      #   sha256 = "0f2g47mql8jjzn2q6lm0cbb5fv62sdqafdvx5g8s3lqri1sca14n";
      #   name   = "dce";
      # })
    ]
    ++ lib.optional withQuagga (fetchFromGitHub {
      owner  = "direct-code-execution";
      repo   = "ns-3-dce-quagga";
      rev    = "dce-${dce-version}";
      sha256 = "1bbb1v33mv1p8isiggg9qg3a8hs0yq5s1dqz22lbdx55jrdxm7rb";
      name   = "dce-quagga";
    })
    ;

    postUnpack = lib.optionalString withQuagga ''
      # mv won't work :'(
      cp -R dce-quagga/ ${sourceRoot}/myscripts
    '';

    sourceRoot = "dce";

    buildInputs = [ ns3forDce gcc pythonEnv ]
      ++ lib.optionals pythonSupport [ castxml ncurses ]
      ++ lib.optionals withExamples [ openssl ]
      ;

    nativeBuildInputs = [ pkgconfig ];

    doCheck = true;

    patchPhase = ''
      patchShebangs test.py
    '';
    configurePhase = ''
      runHook preConfigure

      ${pythonEnv.interpreter} ./waf configure --prefix=$out \
      --with-ns3=${ns3forDce} --with-python=${pythonEnv.interpreter} \
        ${stdenv.lib.optionalString (!withExamples) "--disable-examples "} ${stdenv.lib.optionalString (!doCheck) " --disable-tests" };

      runHook postConfigure
    '';

    buildPhase=''
      ${pythonEnv.interpreter} ./waf build
    '';

    hardeningDisable = [ "all" ];

    # shellHook= stdenv.lib.optionalString withExamples ''
    #   export DCE_PATH=${iperf-dce}/bin
    # '';

    meta = {
      homepage = https://www.nsnam.org/overview/projects/direct-code-execution;
      license = stdenv.lib.licenses.gpl3;
      description = "Run real applications/network stacks in the simulator ns-3";
      platforms = with stdenv.lib.platforms; unix;
    };
  };
in
  dce
