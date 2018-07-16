{ buildPythonPackage
, fetchPypi
, isPy3k
, stdenv
, numpy
, wxPython
, matplotlib
, pycairo
, python-gnupg
, xlrd
, xlwt
, jedi
, pyenchant
, basemap
, pygtk
, makeDesktopItem
}:

buildPythonPackage rec {
  pname = "pyspread";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ffdfd219450f5f22ee51eb633c04941d1d608e1ceb4d3357d07683b7e5b84f83";
  };

  propagatedBuildInputs = [ numpy wxPython matplotlib pycairo python-gnupg xlrd xlwt jedi pyenchant basemap pygtk ];
  # Could also (optionally) add pyrsvg and python bindings for libvlc

  # Tests try to access X Display
  doCheck = false;

  disabled = isPy3k;

  desktopItem = makeDesktopItem rec {
    name = pname;
    exec = name;
    icon = name;
    desktopName = "Pyspread";
    genericName = "Spreadsheet";
    comment = meta.description;
    categories = "Development;Spreadsheet;";
  };

  postInstall = ''
    mkdir -p $out/share/applications
    cp $desktopItem/share/applications/* $out/share/applications
  '';

  meta = with stdenv.lib; {
    description = "Pyspread is a non-traditional spreadsheet application that is based on and written in the programming language Python";
    homepage = https://manns.github.io/pyspread/;
    license = licenses.gpl3;
  };
}
