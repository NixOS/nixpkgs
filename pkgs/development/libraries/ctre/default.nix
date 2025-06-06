{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "ctre";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "hanickadot";
    repo = "compile-time-regular-expressions";
    rev = "v${version}";
    hash = "sha256-Fmx8eKo4UHSYQa5RL70VmaogQj+ILVA1gfpaVE8+MlQ=";
  };

  nativeBuildInputs = [ cmake ];

  postPatch = ''
    substituteInPlace packaging/pkgconfig.pc.in \
      --replace "\''${prefix}/" ""
  '';

  dontBuild = true;

  meta = with lib; {
    description = "Fast compile-time regular expressions library";
    longDescription = ''
      Fast compile-time regular expressions with support for
      matching/searching/capturing during compile-time or runtime.
    '';
    license = licenses.asl20;
    homepage = "https://compile-time.re";
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.all;
  };
}
