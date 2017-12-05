{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, mozlog
, mozdevice
}:

buildPythonPackage rec {
  pname = "mozversion";
  version = "1.4";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15ipddn6bpqxl590cy37fj52vgpa4faw2dax1mwvdxj7b18s3pwh";
  };

  propagatedBuildInputs = [ mozlog mozdevice ];

  meta = {
    description = "Application version information library";
    homepage = https://wiki.mozilla.org/Auto-tools/Projects/Mozbase;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ raskin ];
  };
}
