{ lib, stdenv, fetchurl, Libsystem }:
let
  version = "110.95";
  baseurl = "http://smlnj.cs.uchicago.edu/dist/working/${version}";

  arch = if stdenv.is64bit
    then "64"
    else "32";

  boot32 = { url = "${baseurl}/boot.x86-unix.tgz";
             sha256 = "07bcrvjphyin1ygjbymcqhd1mbfk4hff82wmxcllh77lr28l5dxf"; };
  boot64 = { url = "${baseurl}/boot.amd64-unix.tgz";
             sha256 = "1zn96a83kb6bn6228yfjsvb58m2qxw9k4j3qz0p9c8za479w4ch6"; };

  bootBinary = if stdenv.is64bit
               then boot64
               else boot32;

  sources = map fetchurl [
    bootBinary
    { url = "${baseurl}/config.tgz";              sha256 = "09srqxkxl86iaz6l6dz83c1apsac0pxpfq6b74i6l0nfl261jibw"; }
    { url = "${baseurl}/cm.tgz";                  sha256 = "0gh8inrb07z597axw8qipwyx52m8nac5d5r0rvgzvdnnjg9nr9zy"; }
    { url = "${baseurl}/compiler.tgz";            sha256 = "1kk6jwzyc261l5nii3n8rwccmgvcj1mg5fgycfsfsiyyy1v8xfx7"; }
    { url = "${baseurl}/runtime.tgz";             sha256 = "17i069h5cv411sgzx3ynlf4v3wlrxiba9bwy1b0x0cyhs879kppc"; }
    { url = "${baseurl}/system.tgz";              sha256 = "0s8ij3wfxpjrmrwxrgrirfxjj8vkda6l32j88al5q1ic3ncwc58s"; }
    { url = "${baseurl}/MLRISC.tgz";              sha256 = "1v2d3gjxrcgc95x5glqcw0nfp13aapkcw03fyi70m3k1yc61izmz"; }
    { url = "${baseurl}/smlnj-lib.tgz";           sha256 = "04i11ki8v9s7yz3lg6b0djhi03zzkzav0b5cr81ypxlkmf4hh6bp"; }
    { url = "${baseurl}/old-basis.tgz";           sha256 = "1ryqpy0n7c9gd995ndmjvaci74f95nr8n1jjgm28yd1sn7hnavhi"; }
    { url = "${baseurl}/ckit.tgz";                sha256 = "18mcs3j8c5gq9cmck7r175am60blaznqmhzyir622yfc8fpw1map"; }
    { url = "${baseurl}/nlffi.tgz";               sha256 = "16mrl5aqbgsgljxa3z8kj5max9drddml34bq7rn1i78594jfvkwk"; }
    { url = "${baseurl}/cml.tgz";                 sha256 = "00x784nv1pi6534k3vva26i9qx84cvw242vgwbs5020zkm6gvrmn"; }
    { url = "${baseurl}/eXene.tgz";               sha256 = "143825h36v6z77kwvrvpszgwnhmjs3yldb18i9z4lwkqfb4kn7f7"; }
    { url = "${baseurl}/ml-lpt.tgz";              sha256 = "17ly9h9ry8r94dx6lkas6w2cxknwkpma4z9pj8rgzmd3w6qm7j1z"; }
    { url = "${baseurl}/ml-lex.tgz";              sha256 = "1ja3l2kiq17754c58mwdiqi25f7ax0cji2wk0vq4872iwwxc22px"; }
    { url = "${baseurl}/ml-yacc.tgz";             sha256 = "1m48nkwvw87yg39sjihlw8na5m34bzz3d4zpfbjaj2f75fkjy3jf"; }
    { url = "${baseurl}/ml-burg.tgz";             sha256 = "13nbvbah7bn8gjm4gi41m412vpl69wd6d3x3wzbb6xpia9vm4z4j"; }
    { url = "${baseurl}/pgraph.tgz";              sha256 = "1aizkl8avz01kx221xy5z7a1a1b5xqn2hrk66wr8d0iav2nh5c98"; }
    { url = "${baseurl}/trace-debug-profile.tgz"; sha256 = "1c80xgck9sb2rm554nfg4f5mpjkdbrwkcx88pj120056225l10vx"; }
    { url = "${baseurl}/heap2asm.tgz";            sha256 = "1n68drd7as5dy20ccfvgd9cmnhfpfvz7g3f0gc8kpaqaz3vpy36g"; }
    { url = "${baseurl}/smlnj-c.tgz";             sha256 = "1b6svh2kk5211rq73fdwx3sf80d2rshf0dmkkrq5mw4852nzqz3p"; }
    { url = "${baseurl}/doc.tgz";                 sha256 = "021yzhy9maypq4ahz0d0qpr601spndg583fn9mapv6rl42kwhjq6"; }
    { url = "${baseurl}/asdl.tgz";                sha256 = "0nqavqcbidwnphbbwjrxhpy8glbyad51wy0cpqimbsw3sgns0zkd"; }
  ];
in stdenv.mkDerivation {
  pname = "smlnj";
  inherit version;

  inherit sources;

  patchPhase = ''
    sed -i '/PATH=/d' config/_arch-n-opsys base/runtime/config/gen-posix-names.sh
    echo SRCARCHIVEURL="file:/$TMP" > config/srcarchiveurl
    patch --verbose config/_heap2exec ${./heap2exec.diff}
  '' + lib.optionalString stdenv.isDarwin ''
    # Locate standard headers like <unistd.h>
    substituteInPlace base/runtime/config/gen-posix-names.sh \
      --replace "\$SDK_PATH/usr" "${Libsystem}"
  '';

  unpackPhase = ''
    for s in $sources; do
      b=$(basename $s)
      cp $s ''${b#*-}
    done
    unpackFile config.tgz
    mkdir base
    ./config/unpack $TMP runtime
  '';

  buildPhase = ''
    ./config/install.sh -default ${arch}
  '';

  installPhase = ''
    mkdir -pv $out
    cp -rv bin lib $out

    cd $out/bin
    for i in *; do
      sed -i "2iSMLNJ_HOME=$out/" $i
    done
  '';

  meta = with lib; {
    description = "Standard ML of New Jersey, a compiler";
    homepage    = "http://smlnj.org";
    license     = licenses.bsd3;
    platforms   = [ "x86_64-linux" "i686-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "sml";
    # never built on x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
