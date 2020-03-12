{ stdenv, lib, buildPythonPackage, fetchPypi, fetchpatch, pytz, pytest, freezegun, glibcLocales }:

buildPythonPackage rec {
  pname = "Babel";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e86135ae101e31e2c8ec20a4e0c5220f4eed12487d5cf3f78be7e98d3a57fc28";
  };

  patches = [
    # The following 2 patches fix the test suite failing on nix < 2.3 with
    # Python < 3 because those nix versions do not run in a pseudoterminal,
    # which makes Python 2 not set the default encoding to UTF-8, and the
    # Babel code crashes when printing a warning in that case.
    # See #75676 and https://github.com/python-babel/babel/pull/691.
    # It is important to fix this because otherwise Babel is not buildable
    # with older nix versions (e.g. on machines used as --builders).
    # TODO: Remove at release > 2.8.0.
    (fetchpatch {
      name = "Babel-Introduce-invariant-that-invalid_pofile-takes-unicode-line.patch";
      url = "https://github.com/python-babel/babel/commit/f4f6653e6aa053724d2c6dc0ee71dcb928013352.patch";
      sha256 = "1kyknwn9blspcf9yxmgdiaxdii1dnkblyhcflqwhxyl1mss1dxv5";
    })
    (fetchpatch {
      name = "Babel-Fix-unicode-printing-error-on-Python-2-without-TTY.patch";
      url = "https://github.com/python-babel/babel/commit/da7f31143847659b6b74d802618b03438aceb350.patch";
      sha256 = "09yny8614knr8ngrrddmqzkxk70am135rccv2ncc6dji4xbqbfln";
    })
  ];

  propagatedBuildInputs = [ pytz ];

  checkInputs = [ pytest freezegun ];

  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    homepage = http://babel.edgewall.org;
    description = "A collection of tools for internationalizing Python applications";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
