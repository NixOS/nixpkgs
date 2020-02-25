{ stdenv
, fetchFromGitHub
, cmake
, perl
, bzip2
}:

stdenv.mkDerivation rec {
  pname = "xcfun";
  version = "1.0.X";

  src = fetchFromGitHub {
    owner = "dftlibs";
    repo = pname;
    rev = "4436c86f905119628a5155c27b347f31d576f5af"; # tip of stable-1.X
    sha256 = "0b53f11pr0xydiz6hqn0crymahkhrhh5yi96xr8gglj0j8rk7p1v";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    perl
    bzip2
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=ON"
  ];

  doCheck = true;
  checkPhase = ''
    ctest --progress
  '';

  meta = with stdenv.lib; {
    description = "Exchange-correlation functionals with arbitrary order derivatives";
    homepage = "https://xcfun.readthedocs.io/en/latest/";
    downloadPage = "https://github.com/dftlibs/xcfun/releases";
    license = licenses.mpl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
