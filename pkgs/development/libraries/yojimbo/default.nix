{ lib, stdenv, fetchFromGitHub, premake5, doxygen, libsodium, mbedtls_2 }:

stdenv.mkDerivation {
  pname = "yojimbo";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "networkprotocol";
    repo = "yojimbo";
    rev = "e02219c102d9b440290539036992d77608eab3b0";
    sha256 = "0jn25ddv73hwjals883a910m66kwj6glxxhnmn96bpzsvsaimnkr";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ premake5 doxygen ];
  propagatedBuildInputs = [ libsodium mbedtls_2 ];

  postBuild = ''
    premake5 docs
  '';

  installPhase = ''
    install -Dm555 -t $out/lib bin/libyojimbo.a
    install -Dm444 -t $out/include yojimbo.h
    mkdir -p $out/share/doc/yojimbo
    cp -r docs/html $out/share/doc/yojimbo
  '';

  doCheck = true;

  meta = with lib; {
    description = "A network library for client/server games with dedicated servers";
    longDescription = ''
      yojimbo is a network library for client/server games with dedicated servers.
      It's designed around the networking requirements of competitive multiplayer games like first person shooters.
      As such it provides a time critical networking layer on top of UDP, with a client/server architecture supporting up to 64 players per-dedicated server instance.
    '';
    homepage = "https://github.com/networkprotocol/yojimbo";
    license = licenses.bsd3;
    platforms = platforms.x86_64;
    maintainers = with maintainers; [ paddygord ];
  };
}
