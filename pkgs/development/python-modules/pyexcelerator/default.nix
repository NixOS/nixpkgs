{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "pyexcelerator";
  version = "0.6.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18rcnc9f71lj06h8nppnv6idzb7xfmh2rp1zfqayskcg686lilrb";
  };

  disabled = isPy3k;

  # No tests are included in archive
  doCheck = false;

  meta = with stdenv.lib; {
    description = "library for generating Excel 97/2000/XP/2003 and OpenOffice Calc compatible spreadsheets.";
    homepage = "https://sourceforge.net/projects/pyexcelerator";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ womfoo ];
  };

}
