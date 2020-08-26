{ stdenv
, fetchFromGitHub
, autoreconfHook
, wxGTK
, sqlite
, darwin
}:

stdenv.mkDerivation rec {
  pname = "wxsqlite3";
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "utelle";
    repo = "wxsqlite3";
    rev = "v${version}";
    sha256 = "0snsysfrr5h66mybls8r8k781v732dlfn4jdnmk348jgvny275fj";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ wxGTK sqlite ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa darwin.stubs.setfile darwin.stubs.rez darwin.stubs.derez ];

  meta = with stdenv.lib; {
    homepage = "https://utelle.github.io/wxsqlite3/";
    description = "A C++ wrapper around the public domain SQLite 3.x for wxWidgets";
    platforms = platforms.unix;
    maintainers = with maintainers; [ vrthra ];
    license = [ licenses.lgpl2 ];
  };
}
