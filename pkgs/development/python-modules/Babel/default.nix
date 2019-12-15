{ stdenv, lib, buildPythonPackage, fetchPypi, pytz, pytest, freezegun, isPy3k, glibcLocales }:

buildPythonPackage rec {
  pname = "Babel";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e86135ae101e31e2c8ec20a4e0c5220f4eed12487d5cf3f78be7e98d3a57fc28";
  };

  propagatedBuildInputs = [ pytz ];

  checkInputs = [ pytest freezegun ]
    # Without this, tests fail with a unicode error on Python < 3
    # (checked with 2.7) if glibc is used, see:
    # https://github.com/NixOS/nixpkgs/issues/74904
    ++ lib.optionals (!isPy3k && stdenv.hostPlatform.libc == "glibc") [ glibcLocales ];

  doCheck = !stdenv.isDarwin
    # Test failure on musl when Python < 3 (checked with 2.7) is used:
    # https://github.com/NixOS/nixpkgs/issues/74904 (like above).
    && !(stdenv.hostPlatform.isMusl && !isPy3k);

  meta = with lib; {
    homepage = http://babel.edgewall.org;
    description = "A collection of tools for internationalizing Python applications";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
