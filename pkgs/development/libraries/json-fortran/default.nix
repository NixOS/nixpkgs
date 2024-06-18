{ stdenv, lib, fetchFromGitHub, gfortran, cmake }:

stdenv.mkDerivation rec {
  pname = "json-fortran";
  version = "9.0.1";

  src = fetchFromGitHub {
    owner = "jacobwilliams";
    repo = pname;
    rev = version;
    hash = "sha256-nhT2zLyt3ORi35h9KzOiIuD50GGUCZ/Z5SX8UF3rqQs=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  cmakeFlags = [
    "-DUSE_GNU_INSTALL_CONVENTION=ON"
  ];

  # Due to some misconfiguration in CMake the Fortran modules end up in $out/$out.
  # Move them back to the desired location.
  postInstall = ''
    mv $out/$out/include $out/.
    rm -r $out/nix
  '';

  meta = with lib; {
    description = "Modern Fortran JSON API";
    homepage = "https://github.com/jacobwilliams/json-fortran";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
