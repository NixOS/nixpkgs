{ lib, stdenv, fetchzip, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "libpostal";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "openvenues";
    repo = "libpostal";
    rev = "v${version}";
    sha256 = "sha256-gQTD2LQibaB2TK0SbzoILAljAGExURvDcF3C/TfDXqk=";
  };

  languageClassifier = fetchzip {
    url = "https://github.com/openvenues/libpostal/releases/download/v1.0.0/language_classifier.tar.gz";
    sha256 = "sha256-/Gn931Nx4UDBaiFUgGqC/NJUIKQ5aZT/+OYSlcfXva8=";
    stripRoot = false;
  };

  libpostalData = fetchzip {
    url = "https://github.com/openvenues/libpostal/releases/download/v1.0.0/libpostal_data.tar.gz";
    sha256 = "sha256-FpGCkkRhVzyr08YcO0/iixxw0RK+3Of0sv/DH3GbbME=";
    stripRoot = false;
  };

  parser = fetchzip {
    url = "https://github.com/openvenues/libpostal/releases/download/v1.0.0/parser.tar.gz";
    sha256 = "sha256-OHETb3e0GtVS2b4DgklKDlrE/8gxF7XZ3FwmCTqZbqQ=";
    stripRoot = false;
  };

  data = stdenv.mkDerivation {
    name = "libpostal-data";
    buildCommand = ''
      mkdir -p $out/data/libpostal

      ln -s ${languageClassifier}/language_classifier   $out/data/libpostal/languageClassifier
      ln -s ${libpostalData}/transliteration            $out/data/libpostal/transliteration
      ln -s ${libpostalData}/numex                      $out/data/libpostal/numex
      ln -s ${libpostalData}/address_expansions         $out/data/libpostal/address_expansions
      ln -s ${parser}/address_parser                    $out/data/libpostal/address_parser
    '';
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--datadir=${data}/data"
    "--disable-data-download"
  ] ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "--disable-sse2" ];

  meta = with lib; {
    description = "A C library for parsing/normalizing street addresses around the world. Powered by statistical NLP and open geo data";
    homepage = "https://github.com/openvenues/libpostal";
    license = licenses.mit;
    maintainers = [ maintainers.Thra11 ];
    mainProgram = "libpostal_data";
    platforms = platforms.unix;
  };
}
