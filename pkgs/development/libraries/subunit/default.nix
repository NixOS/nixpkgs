{ stdenv, fetchFromGitHub, pkg-config, autoreconfHook, check, cppunit, perl, pythonPackages }:

# NOTE: for subunit python library see pkgs/top-level/python-packages.nix

stdenv.mkDerivation rec {
  pname = "subunit";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "testing-cabal";
    repo = pname;
    rev = version;
    sha256 = "1hk5v8gg5azwrc079xqigj0sp6qm47vzg1qwjbvb8dbjwlg75rvz";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ check cppunit perl pythonPackages.wrapPython ];

  propagatedBuildInputs = with pythonPackages; [ testtools testscenarios ];

  postFixup = "wrapPythonPrograms";

  meta = with stdenv.lib; {
    description = "A streaming protocol for test results";
    homepage = "https://launchpad.net/subunit";
    downloadPage = "https://github.com/testing-cabal/subunit";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
