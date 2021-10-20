{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, docutils
, readme_renderer
, packaging
, pygments
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "restview";
  version = "2.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p1jgdvc04ws8kga3r0vrq3m0b52qw3clwyydl96a13wb3mrf03r";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/mgedmin/restview/commit/a1ded30a87c65f3ce59a18497a7fc5099317c2be.patch";
      sha256 = "1ax7pih456a3nbj8qrrq7hqigbyag4ihzpn6bm0z4y74d0r3v8a5";
    })
  ];

  propagatedBuildInputs = [ docutils readme_renderer packaging pygments ];
  checkInputs = [ mock pytestCheckHook ];

  meta = {
    description = "ReStructuredText viewer";
    homepage = "https://mg.pov.lt/restview/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ koral ];
  };
}
