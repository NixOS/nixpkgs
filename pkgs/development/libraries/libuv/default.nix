{ stdenv, lib, fetchFromGitHub, autoconf, automake, libtool }:

let
  stable = "stable";
  unstable = "unstable";

  meta = with lib; {
    description = "A multi-platform support library with a focus on asynchronous I/O";
    homepage    = https://github.com/joyent/libuv;
    maintainers = with maintainers; [ cstrahan ];
    platforms   = with platforms; linux ++ darwin;
  };

  mkName = stability: version:
    if stability == stable
    then "libuv-${version}"
    else "libuv-${stability}-${version}";

  mkSrc = version: sha256: fetchFromGitHub {
    owner = "joyent";
    repo = "libuv";
    rev = "v${version}";
    inherit sha256;
  };

  # for versions < 0.11.6
  mkWithoutAutotools = stability: version: sha256: stdenv.mkDerivation {
    name = mkName stability version;
    src = mkSrc version sha256;
    buildPhase = lib.optionalString stdenv.isDarwin ''
      mkdir extrapath
      ln -s /usr/sbin/dtrace extrapath/dtrace
      export PATH=$PATH:`pwd`/extrapath
    '' + ''
      mkdir build
      make builddir_name=build

      rm -r build/src
      rm build/libuv.a
      cp -r include build

      mkdir build/lib
      mv build/libuv.* build/lib

      pushd build/lib
      lib=$(basename libuv.*)
      ext="''${lib##*.}"
      mv $lib libuv.10.$ext
      ln -s libuv.10.$ext libuv.$ext
      popd
    '';
    installPhase = ''
      cp -r build $out
    '';
    inherit meta;
  };

  # for versions > 0.11.6
  mkWithAutotools = stability: version: sha256: stdenv.mkDerivation {
    name = mkName stability version;
    src = mkSrc version sha256;
    buildInputs = [ automake autoconf libtool ];
    preConfigure = ''
      LIBTOOLIZE=libtoolize ./autogen.sh
    '';
    inherit meta;
  };

  toVersion = with lib; name:
    replaceChars ["_"] ["."] (removePrefix "v" name);

in

  with lib;

  mapAttrs (v: h: mkWithoutAutotools stable (toVersion v) h) {
    v0_10_27 = "0i00v216ha74xi374yhgmfrb4h84q2w4y1ync3y1qsngbm8irjhg";
  }
  //
  mapAttrs (v: h: mkWithAutotools unstable (toVersion v) h) {
    # Versions >= 0.11.1 and < 0.11.6 do not build a dynamic library
    v0_11_6  = "15h903hz6kn8j1lp1160ia7llx0ypa5ch8ygkwpmrm31p50ng8r4";
    v0_11_7  = "1l6hrz3g2c7qspy28inbrcd7byn2sncd42ncf4pr0ifpkkj083hh";
    v0_11_8  = "0aag2v7bfi7kksna0867srlqcjxn8m287bpl2j5k11d07m382zs1";
    v0_11_9  = "12ap0ix5ra24f30adgdr48l175vxfmh398mlilm8kdkld0dqfx24";
    v0_11_10 = "17mn9xbygc2jpqv4a068i57rcp585bmcalpb9jpyz1jf030lllyy";
    v0_11_11 = "1l06sznvd5nxzg3fqqb451g4fzygyb37apqyhyvbdb6dmklcm7xk";
    v0_11_12 = "1kwqd3wk06mffhglawx7b2g4yddkg5597aa5jyw2zhzwkz2z4a27";
    v0_11_13 = "0z30ljwgxbm120dy0i4knhj5zw6q7jcx5wi9v0v51ax6mhdgqy8a";
    v0_11_14 = "0bk1bchfkbyyry3d4ggv754w5fyj6qbivbd42ggcr0hq55h49iwg";
    v0_11_15 = "09qayz2k0337h7jbf8zs9lyxgp3ln0gq37r43wixfll7jjjkacvd";
    v0_11_16 = "06jrwwnliqadqgp7fn2093xxljiz8iwdyywh2yljyp4zk8r4vzis";
    v0_11_17 = "0i6nlxnlxwzpib0sp1191h9yymfvgwjwciiq9avcqljiklfg432r";
    v0_11_18 = "0jxrfxf4iq34fjgbwdrvi36hqzgph87928n4q4gchpahywf2pjxk";
    v0_11_19 = "16aw8jx571xxc6am4sbz17j2wb9pylv1svsmwxbczb3vd624vm32";
    v0_11_20 = "0r7cyzxysgcfl4h9xis050b7x8cvmrwzwh1rr545q53j0gjxvzvi";
    v0_11_21 = "0bxjzrlcs2f0va26i0ahvcpjbb0j66rq74smi95s6q73zl99n326";
    v0_11_22 = "0r6nfavsndm1dzinzzxndr2h75g33vigx21z3f7w2x7qwa8a8hpp";
    v0_11_23 = "01dlmpk8a4zvq6lm88bsfi7dzhl7xvma7q5ygi2x5ghdm4svki1m";
    v0_11_24 = "1hygn81iwbdshzrq603qm6k1r7pjflx9qqazmlb72c3vy1hq21c6";
    v0_11_25 = "1abszivlxf0sddwvcj3jywfsip5q9vz6axvn40qqyl8sjs80zcvj";
    v0_11_26 = "1pfjdwrxhqz1vqcdm42g3j45ghrb4yl7wsngvraclhgqicff1sc3";
  }
