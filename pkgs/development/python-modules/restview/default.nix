{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, docutils
, readme_renderer
, pygments
, mock
}:

buildPythonPackage rec {
  pname = "restview";
  version = "2.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "de87c84f19526bd4a76505f6d40b51b7bb03ca43b6067c93f82f1c7237ac9e84";
  };

  propagatedBuildInputs = [ docutils readme_renderer pygments ];
  checkInputs = [ mock ];

  patches = [
    # fix tests after readme_renderer update
    # TODO remove on next update
    (fetchpatch {
      url = "https://github.com/mgedmin/restview/commit/541743ded13ae55dea4c437046984a5f13d06e8b.patch";
      sha256 = "031b1dlqx346bz7afpc011lslnq771lnxb6iy1l2285pph534bci";
    })
  ];

  postPatch = ''
    # dict order breaking tests
    sed -i 's@<a href="http://www.example.com" rel="nofollow">@...@' src/restview/tests.py
  '';

  meta = {
    description = "ReStructuredText viewer";
    homepage = https://mg.pov.lt/restview/;
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ koral ];
  };
}
