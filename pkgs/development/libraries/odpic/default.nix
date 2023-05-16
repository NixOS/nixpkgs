{ lib, stdenv, fetchFromGitHub, fixDarwinDylibNames, oracle-instantclient, libaio }:

let
<<<<<<< HEAD
  version = "5.0.0";
  libPath = lib.makeLibraryPath [ oracle-instantclient.lib ];

in
stdenv.mkDerivation {
=======
  version = "4.6.1";
  libPath = lib.makeLibraryPath [ oracle-instantclient.lib ];

in stdenv.mkDerivation {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  inherit version;

  pname = "odpic";

  src = fetchFromGitHub {
    owner = "oracle";
    repo = "odpi";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-ZRkXd7D4weCfP6R7UZD2+saNiNa+XXVhfiWIlxBObmU=";
=======
    sha256 = "sha256-3kJI3qRgqrithhGq7lO1r94T/P3SamDgLN13hKzmj5I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = lib.optional stdenv.isDarwin fixDarwinDylibNames;

  buildInputs = [ oracle-instantclient ]
    ++ lib.optionals stdenv.isLinux [ libaio ];

  dontPatchELF = true;
<<<<<<< HEAD
  makeFlags = [ "PREFIX=$(out)" "CC=${stdenv.cc.targetPrefix}cc" "LD=${stdenv.cc.targetPrefix}cc" ];
=======
  makeFlags = [ "PREFIX=$(out)" "CC=${stdenv.cc.targetPrefix}cc" "LD=${stdenv.cc.targetPrefix}cc"];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postFixup = ''
    ${lib.optionalString (stdenv.isLinux) ''
      patchelf --set-rpath "${libPath}:$(patchelf --print-rpath $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary})" $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary}
    ''}
    ${lib.optionalString (stdenv.isDarwin) ''
      install_name_tool -add_rpath "${libPath}" $out/lib/libodpic${stdenv.hostPlatform.extensions.sharedLibrary}
    ''}
<<<<<<< HEAD
  '';
=======
    '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Oracle ODPI-C library";
    homepage = "https://oracle.github.io/odpi/";
<<<<<<< HEAD
    maintainers = with maintainers; [ mkazulak ];
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    hydraPlatforms = [ ];
=======
    maintainers = with maintainers; [ mkazulak flokli ];
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
    hydraPlatforms = [];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
