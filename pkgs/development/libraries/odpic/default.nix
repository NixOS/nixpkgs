{ lib, stdenv, fetchFromGitHub, fixDarwinDylibNames, oracle-instantclient, libaio }:

let
  version = "4.1.0";
  libPath = lib.makeLibraryPath [ oracle-instantclient.lib ];

in stdenv.mkDerivation {
  inherit version;

  pname = "odpic";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "odpi";
    rev = "v${version}";
    sha256 = "1zk08z74q7njbj329xfy8aszphj27rqlkhsyglai60wfzl6mcf4x";
  };

  nativeBuildInputs = lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs = [ oracle-instantclient ]
    ++ lib.optionals stdenv.isLinux [ libaio ];

  dontPatchELF = true;
  makeFlags = [ "PREFIX=$(out)" "CC=cc" "LD=cc"];

  postFixup = ''
    ${lib.optionalString (stdenv.isLinux) ''
      patchelf --set-rpath "${libPath}:$(patchelf --print-rpath $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary})" $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary}
    ''}
    ${lib.optionalString (stdenv.isDarwin) ''
      install_name_tool -add_rpath "${libPath}" $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary}
    ''}
    '';

  meta = with lib; {
    description = "Oracle ODPI-C library";
    homepage = "https://oracle.github.io/odpi/";
    maintainers = with maintainers; [ mkazulak flokli ];
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    hydraPlatforms = [];
  };
}
