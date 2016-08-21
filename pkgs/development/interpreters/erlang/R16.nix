{ mkDerivation, fetchurl }:

mkDerivation rec {
  version = "16B03-1";

  src = fetchurl {
    url = "http://www.erlang.org/download/otp_src_R${version}.tar.gz";
    sha256 = "1rvyfh22g1fir1i4xn7v2md868wcmhajwhfsq97v7kn5kd2m7khp";
  };

  patchPhase = ''
    sed -i "s@/bin/rm@rm@" lib/odbc/configure erts/configure
  '';

  preConfigure = ''
    export HOME=$PWD/../
    sed -e s@/bin/pwd@pwd@g -i otp_build
  '';

  postInstall = let
    manpages = fetchurl {
      url = "http://www.erlang.org/download/otp_doc_man_R${version}.tar.gz";
      sha256 = "17f3k5j17rdsah18gywjngip6cbfgp6nb9di6il4pahmf9yvqc8g";
    };
  in ''
    ln -s $out/lib/erlang/lib/erl_interface*/bin/erl_call $out/bin/erl_call
    tar xf "${manpages}" -C "$out/lib/erlang"
    for i in "$out"/lib/erlang/man/man[0-9]/*.[0-9]; do
      prefix="''${i%/*}"
      ensureDir "$out/share/man/''${prefix##*/}"
      ln -s "$i" "$out/share/man/''${prefix##*/}/''${i##*/}erl"
    done
  '';
}
