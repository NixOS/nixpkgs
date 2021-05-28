{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "korean-lunar-calendar";
  version = "0.2.1";

  src = fetchPypi {
    inherit version;
    pname = "korean_lunar_calendar";
    sha256 = "0p97r21298ipgvsqh978aq2n6cvybzp8bskcvj15mm1f76qm9khj";
  };

  # no real tests
  pythonImportsCheck = [ "korean_lunar_calendar" ];

  meta = with stdenv.lib; {
    description = "A library to convert Korean lunar-calendar to Gregorian calendar.";
    homepage = "https://github.com/usingsky/korean_lunar_calendar_py";
    license = licenses.mit;
    maintainers = [ maintainers.ris ];
  };
}
