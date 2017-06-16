{ pkgs, mkDerivation }:

mkDerivation rec {
  baseName = "erlang";
  version = "16B02";

  src = pkgs.fetchFromGitHub {
    owner = "basho";
    repo = "otp";
    rev = "OTP_R16B02_basho8";
    sha256 = "1w0hbm0axxxa45v3kl6bywc9ayir5vwqxjpnjlzc616ldszb2m0x";
  };

  preConfigure = ''
    export HOME=$PWD/../
    export LANG=C
    export ERL_TOP=$(pwd)
    sed -e s@/bin/pwd@pwd@g -i otp_build
    sed -e s@"/usr/bin/env escript"@$(pwd)/bootstrap/bin/escript@g -i lib/diameter/bin/diameterc

    ./otp_build autoconf
  '';

  enableHipe = false;

  # Do not install docs, instead use prebuilt versions.
  installTargets = "install";
  postInstall = let
    manpages = pkgs.fetchurl {
      url = "http://www.erlang.org/download/otp_doc_man_R${version}.tar.gz";
      sha256 = "12apxjmmd591y9g9bhr97z5jbd1jarqg7wj0y2sqhl21hc1yp75p";
    };
  in ''
    sed -e s@$(pwd)/bootstrap/bin/escript@$out/bin/escript@g -i $out/lib/erlang/lib/diameter-1.4.3/bin/diameterc

    tar xf "${manpages}" -C "$out/lib/erlang"
    for i in "$out"/lib/erlang/man/man[0-9]/*.[0-9]; do
      prefix="''${i%/*}"
      ensureDir "$out/share/man/''${prefix##*/}"
      ln -s "$i" "$out/share/man/''${prefix##*/}/''${i##*/}erl"
    done
  '';

  meta = {
    homepage = "https://github.com/basho/otp/";
    description = "Programming language used for massively scalable soft real-time systems, Basho fork";

    longDescription = ''
      Erlang is a programming language used to build massively scalable
      soft real-time systems with requirements on high availability.
      Some of its uses are in telecoms, banking, e-commerce, computer
      telephony and instant messaging. Erlang's runtime system has
      built-in support for concurrency, distribution and fault
      tolerance.
      This version of Erlang is Basho's version, forked from Ericsson's
      repository.
    '';

    platforms = ["x86_64-linux" "x86_64-darwin"];
    license = pkgs.stdenv.lib.licenses.asl20;
    maintainers = with pkgs.stdenv.lib.maintainers; [ mdaiter ];
  };
}
