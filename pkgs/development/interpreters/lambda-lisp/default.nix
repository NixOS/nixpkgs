# Lambda Lisp has several backends, here we are using
# the blc one. Ideally, this should be made into several
# pnames such as lambda-lisp-blc, lambda-lisp-lazyk,
# lambda-lisp-clamb, etc.

{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, wget
}:

stdenv.mkDerivation rec {
  version = "2022-08-18";
  pname = "lambda-lisp-blc";

  src = fetchFromGitHub {
    owner = "woodrush";
    repo = "lambdalisp";
    rev = "2119cffed1ab2005f08ab3cfca92028270f08725";
    sha256 = "sha256-ml2xQ8s8sux+6GwTw8mID3PEOcH6hn8tyc/UI5tFaO0=";
  };

  # Here are the backends needed for later.
  # - [ ] TODO: figure out if they should be packaged
  # - [ ] TODO: setup logic for different backends
  # needed later
  # uniCSrc = fetchurl {
  #   url = "https://tromp.github.io/cl/uni.c";
  #   sha256 = "sha256-JmbqQp2VOkpdPNoSWQmG3uBxdgyIu4r2Ch8bBGyQ4H4=";
  # };

  # needed later
  # clambSrc = fetchFromGitHub {
  #   owner = "irori";
  #   repo = "clamb";
  #   rev = "44c1208697f394e22857195be5ea73bfdd48ebd1";
  #   sha256 = "sha256-1lGg2NBoxAKDCSnnPn19r/hwBC5paAKUnlcsUv3dpNY=";
  # };

  # needed later
  # lazykSrc = fetchFromGitHub {
  #   owner = "irori";
  #   repo = "lazyk";
  #   rev = "5edb0b834d0af5f7413c484eb3795d47ec2e3894";
  #   sha256 = "sha256-1lGg2NBoxAKDCSnnPn19r/hwBC5paAKUnlcsUv3dpNY=";
  # };

  blcSrc = fetchurl {
    url = "https://justine.lol/lambda/Blc.S?v=2";
    sha256 = "sha256-qt7vDtn9WvDoBaLESCyyscA0u74914e8ZKhLiUAN52A=";
  };

  flatSrc = fetchurl {
    url = "https://justine.lol/lambda/flat.lds";
    sha256 = "sha256-HxX+10rV86zPv+UtF+n72obtz3DosWLMIab+uskxIjA=";
  };

  installPhase = ''
    runHook preInstall
    make

    mkdir -p ./build
    cp $blcSrc ./build/Blc.S
    cp $flatSrc ./build/flat.lds
    cd build;
    cat Blc.S | sed -e 's/#define.*TERMS.*//' > Blc.ext.S;
    cc -c -DTERMS=50000000 -o Blc.o Blc.ext.S
    ld.bfd -o Blc Blc.o -T flat.lds
    cd ..;
    mv build/Blc ./bin
    install -D -t $out/bin bin/Blc
    install -D -t $out/lib bin/lambdalisp.blc

    cd build;
    cc ../tools/asc2bin.c -O2 -o asc2bin;
    cd ..;
    mv build/asc2bin ./bin;
    chmod 755 ./bin/asc2bin;
    install -D -t $out/bin bin/asc2bin

    echo -e "#!/bin/sh\n( cat $out/lib/lambdalisp.blc | $out/bin/asc2bin; cat ) | $out/bin/Blc" > lambda-lisp-blc
    chmod +x lambda-lisp-blc

    install -D -t $out/bin lambda-lisp-blc
    runHook postInstall
  '';

  meta = with lib; {
    description = "A Lisp interpreter written in untyped lambda calculus";
    homepage = "https://github.com/woodrush/lambdalisp";
    longDescription = ''
    	LambdaLisp is a Lisp interpreter written as a closed untyped lambda calculus term.
	It is written as a lambda calculus term LambdaLisp = λx. ... which takes a string
	x as an input and returns a string as an output. The input x is the Lisp program
	and the user's standard input, and the output is the standard output. Characters
	are encoded into lambda term representations of natural numbers using the Church
	encoding, and strings are encoded as a list of characters with lists expressed as
	lambdas in the Mogensen-Scott encoding, so the entire computation process solely
	consists of the beta-reduction of lambda terms, without introducing any
	non-lambda-type object.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ cafkafk ];
    platforms = platforms.unix;
  };
}
