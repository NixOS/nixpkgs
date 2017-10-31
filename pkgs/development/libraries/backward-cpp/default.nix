{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "backward-${version}";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "bombela";
    repo = "backward-cpp";
    rev = "v${version}";
    sha256 = "1nx77qamal53rq8qxsjzax6ljawb345a1v3cqmfwa0hx26srxcln";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    cp backward.hpp $out/include

    runHook postInstall
  '';

  meta = with lib; {
    description = "Beautiful stack trace pretty printer for C++";
    homepage = "https://github.com/bombela/backward-cpp";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
