{ stdenv
, buildPythonPackage
, fetchgit
, isPy3k
, pyusb
, pybluez
, pyfantom
, git
}:

buildPythonPackage rec {
  version = "unstable-20160819";
  pname = "nxt-python";
  disabled = isPy3k;

  src = fetchgit {
    url = "https://github.com/Eelviny/nxt-python";
    rev = "479e20b7491b28567035f4cee294c4a2af629297";
    sha256 = "0mcsajhgm2wy4iy2lhmyi3xibgmbixbchanzmlhsxk6qyjccn9r9";
    branchName= "pyusb";
  };

  propagatedBuildInputs = [ pyusb pybluez pyfantom git ];

  # Tests fail on Mac dependency
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python driver/interface for Lego Mindstorms NXT robot";
    homepage = https://github.com/Eelviny/nxt-python;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ leenaars ];
  };

}
