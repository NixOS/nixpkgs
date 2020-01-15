{ stdenv, fetchFromGitHub, fixDarwinDylibNames, oracle-instantclient, libaio }:

let
  version = "3.2.1";
  libPath = stdenv.lib.makeLibraryPath [ oracle-instantclient.lib ];

in stdenv.mkDerivation {
  inherit version;

  pname = "odpic";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "odpi";
    rev = "v${version}";
    sha256 = "1f9gznc7h73cgx32p55rkhzla6l7l9dg53ilwh6zdgdqlp7n018i";
  };

  nativeBuildInputs = stdenv.lib.optional stdenv.isDarwin [ fixDarwinDylibNames ];

  buildInputs = [ oracle-instantclient ]
    ++ stdenv.lib.optionals stdenv.isLinux [ libaio ];

  dontPatchELF = true;
  makeFlags = [ "PREFIX=$(out)" "CC=cc" "LD=cc"];

  postFixup = ''
    ${stdenv.lib.optionalString (stdenv.isLinux) ''
      patchelf --set-rpath "${libPath}:$(patchelf --print-rpath $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary})" $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary}
    ''}
    ${stdenv.lib.optionalString (stdenv.isDarwin) ''
      install_name_tool -add_rpath "${libPath}" $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary}
    ''}
    '';

  meta = with stdenv.lib; {
    description = "Oracle ODPI-C library";
    homepage = "https://oracle.github.io/odpi/";
    maintainers = with maintainers; [ mkazulak flokli ];
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    hydraPlatforms = [];
  };
}
