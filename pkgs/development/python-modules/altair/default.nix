{ stdenv, buildPythonPackage, fetchPypi
, pytest, glibcLocales, vega, pandas, ipython, traitlets }:

buildPythonPackage rec {
  pname = "altair";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e8b222588dde98ec614e6808357fde7fa321118db44cc909df2bf30158d931c0";
  };

  postPatch = ''
    sed -i "s/vega==/vega>=/g" setup.py
  '';

  checkInputs = [ pytest glibcLocales ];

  checkPhase = ''
    export LANG=en_US.UTF-8
    py.test altair --doctest-modules
  '';

  propagatedBuildInputs = [ vega pandas ipython traitlets ];

  meta = with stdenv.lib; {
    description = "A declarative statistical visualization library for Python.";
    homepage = https://github.com/altair-viz/altair;
    license = licenses.bsd3;
    maintainers = with maintainers; [ teh ];
    platforms = platforms.linux;
  };
}
