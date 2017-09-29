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
  name = "${pname}-${version}";
  pname = "pyspread";
  version = "1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0m1a4zvzrfrnc42j8mrbm7747w03nzyl9z02wjagccmlhi6nd9hx";
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
