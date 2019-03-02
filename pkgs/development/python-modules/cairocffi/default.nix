# FIXME: make gdk_pixbuf dependency optional
{ stdenv
, buildPythonPackage
, pythonOlder
, fetchPypi
, lib
, substituteAll
, makeFontsConf
, freefont_ttf
, pytest
, pytestrunner
, glibcLocales
, cairo
, cffi
, withXcffib ? false, xcffib
, python
, glib
, gdk_pixbuf }:

let
  generic = { version, sha256, dlopen_patch, disabled ? false }:
    buildPythonPackage rec {
      pname = "cairocffi";
      inherit version disabled;

      src = fetchPypi {
        inherit pname version sha256;
      };

      LC_ALL = "en_US.UTF-8";

      # checkPhase require at least one 'normal' font and one 'monospace',
      # otherwise glyph tests fails
      FONTCONFIG_FILE = makeFontsConf {
        fontDirectories = [ freefont_ttf ];
      };

      checkInputs = [ pytest pytestrunner glibcLocales ];
      propagatedBuildInputs = [ cairo cffi ] ++ lib.optional withXcffib xcffib;

      checkPhase = ''
        py.test $out/${python.sitePackages}
      '';

      patches = [
        # OSError: dlopen() failed to load a library: gdk_pixbuf-2.0 / gdk_pixbuf-2.0-0
        (substituteAll {
          src = dlopen_patch;
          ext = stdenv.hostPlatform.extensions.sharedLibrary;
          cairo = cairo.out;
          glib = glib.out;
          gdk_pixbuf = gdk_pixbuf.out;
        })
        ./fix_test_scaled_font.patch
      ];

      meta = with lib; {
        homepage = https://github.com/SimonSapin/cairocffi;
        license = licenses.bsd3;
        maintainers = with maintainers; [];
        description = "cffi-based cairo bindings for Python";
      };
    };
in
  {
    cairocffi_1_0 = generic {
      version = "1.0.2";
      sha256 = "01ac51ae12c4324ca5809ce270f9dd1b67f5166fe63bd3e497e9ea3ca91946ff";
      dlopen_patch = ./dlopen-paths.patch;
      disabled = pythonOlder "3.5";
    };

    cairocffi_0_9 = generic {
      version = "0.9.0";
      sha256 = "15386c3a9e08823d6826c4491eaccc7b7254b1dc587a3b9ce60c350c3f990337";
      dlopen_patch = ./dlopen-paths-0.9.patch;
    };
  }
