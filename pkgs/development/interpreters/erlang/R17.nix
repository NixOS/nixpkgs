{ mkDerivation, fetchurl }:

mkDerivation rec {
  version = "17.5";

  src = fetchurl {
    url = "http://www.erlang.org/download/otp_src_${version}.tar.gz";
    sha256 = "0x34hj1a4j3rphqdaapdld7la4sqiqillamcz06wac0vk0684a1w";
  };

  prePatch = ''
    sed -i "s@/bin/rm@rm@" lib/odbc/configure erts/configure
  '';

  preConfigure = ''
    export HOME=$PWD/../
    sed -e s@/bin/pwd@pwd@g -i otp_build
  '';

  # Do not install docs, instead use prebuilt versions.
  installTargets = "install";
  postInstall = let
    manpages = fetchurl {
      url = "http://www.erlang.org/download/otp_doc_man_${version}.tar.gz";
      sha256 = "1hspm285bl7i9a0d4r6j6lm5yk4sb5d9xzpia3simh0z06hv5cc5";
    };
  in ''
    tar xf "${manpages}" -C "$out/lib/erlang"
    for i in "$out"/lib/erlang/man/man[0-9]/*.[0-9]; do
      prefix="''${i%/*}"
      ensureDir "$out/share/man/''${prefix##*/}"
      ln -s "$i" "$out/share/man/''${prefix##*/}/''${i##*/}erl"
    done
  '';
}
