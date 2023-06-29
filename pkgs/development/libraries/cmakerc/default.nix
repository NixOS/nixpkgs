{ lib
, stdenv
, fetchFromGitHub
,
}:
stdenv.mkDerivation rec {
  pname = "cmrc";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "vector-of-bool";
    repo = "cmrc";
    rev = version;
    hash = "sha256-++16WAs2K9BKk8384yaSI/YD1CdtdyXVBIjGhqi4JIk=";
  };

  installPhase = ''
    dir=$out/share/cmakerc
    mkdir -p $dir
    mv CMakeRC.cmake $dir/cmakerc-config.cmake
  '';

  meta = with lib; {
    description = "A Resource Compiler in a Single CMake Script";
    homepage = "https://github.com/vector-of-bool/cmrc";
    license = licenses.mit;
    maintainers = with maintainers; [ guekka ];
  };
}
