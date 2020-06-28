{
  stdenv,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "korean_lunar_calendar";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0p97r21298ipgvsqh978aq2n6cvybzp8bskcvj15mm1f76qm9khj";
  };

  propagatedBuildInputs = [];

  meta = with stdenv.lib; {
    homepage = "https://github.com/usingsky/korean_lunar_calendar_py";
    description = "Here is a library to convert Korean lunar-calendar to Gregorian calendar.";
    license = licenses.mit;
    maintainers = with maintainers; [ usingsky ];
  };
}
