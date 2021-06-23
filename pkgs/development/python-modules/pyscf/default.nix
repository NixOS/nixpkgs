{ buildPythonPackage, lib, fetchFromGitHub, libcint, libxc, xcfun, blas,
  numpy, scipy, h5py, python3
} :

buildPythonPackage rec {
  pname = "pyscf";
  version = "1.7.6.post1";

  src = fetchFromGitHub {
    owner = "pyscf";
    repo = pname;
    rev = "f6c9c6654dd9609c5e467a1edd5c2c076f793acc";
    sha256  = "0xbwkjxxysfpqz72qn6n4a0zr2h6sprbcal8j7kzymh7swjy117w";
  };

  buildInputs = [
    libcint
    libxc
    xcfun
    blas
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    h5py
    python3
  ];

  PYSCF_INC_DIR="${libcint}:${libxc}:${xcfun}";

  doCheck = true;

  meta = with lib; {
    description = "Python-based simulations of chemistry framework";
    homepage = "https://pyscf.github.io/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
