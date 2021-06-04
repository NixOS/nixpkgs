{ buildPythonPackage, lib, fetchPypi, fetchpatch, numpy
, pydantic, pint,  networkx, pytestrunner, pytestcov, pytest
} :

buildPythonPackage rec {
  pname = "qcelemental";
  version = "0.20.0";

  checkInputs = [ pytestrunner pytestcov pytest ];
  propagatedBuildInputs = [ numpy pydantic pint networkx ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "141vw36fmacj897q26kq2bl9l0d23lyqjfry6q46aa9087dcs7ni";
  };

  # FIXME: Fixed upstream but not released yet. Nevertheless critical for correct behaviour.
  # See https://github.com/MolSSI/QCElemental/pull/265
  patches = [
    (fetchpatch {
      name = "SearchPath1.patch";
      url = "https://github.com/MolSSI/QCElemental/commit/2211a4e59690bcb14265a60f199a5efe74fe44db.diff";
      sha256 = "1ibjvmdrc103jdj79xrr11y5yji5hc966rm4ihfhfzgbvfkbjg2l";
    })
    (fetchpatch {
      name = "SearchPath2.patch";
      url = "https://github.com/MolSSI/QCElemental/commit/5a32ce33e8142047b0a00d0036621fe2750e872a.diff";
      sha256 = "0gmg70vdps7k6alqclwdlxkli9d8s1fphbdvyl8wy8xrh46jw6rk";
    })
  ];

  doCheck = true;

  meta = with lib; {
    description = "Periodic table, physical constants, and molecule parsing for quantum chemistry";
    homepage = "http://docs.qcarchive.molssi.org/projects/qcelemental/en/latest/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
