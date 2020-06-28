{
  stdenv,
  buildPythonPackage,
  fetchPypi,
  python-dateutil,
  ephem,
  pytz
}:

buildPythonPackage rec {
  pname = "LunarCalendar";
  version = "0.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0npd9fhfr5x2dgixqs62s4x0i9qs7ng6j9abramw6ly35zr444b8";
  };

  propagatedBuildInputs = [ python-dateutil ephem pytz ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/wolfhong/LunarCalendar";
    description = "LunarCalendar is a Lunar-Solar Converter, containing a number of lunar and solar festivals in China.";
    license = licenses.mit;
    maintainers = with maintainers; [ bletham seanjtaylor ];
  };
}
