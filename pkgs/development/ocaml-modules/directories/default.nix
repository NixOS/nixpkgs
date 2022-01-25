{ lib, fetchFromGitHub, buildDunePackage }:

buildDunePackage rec {
  pname = "directories";
  version = "0.2";
  useDune2 = true;

  minimumOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "ocamlpro";
    repo = pname;
    rev = version;
    sha256 = "0s7ginh0g0fhw8xf9v58cx99a8q9jqsf4i0p134m5qzf84qpjwff";
  };

  meta = {
    homepage = "https://github.com/ocamlpro/directories";
    description = "An OCaml library that provides configuration, cache and data paths (and more!) following the suitable conventions on Linux, macOS and Windows";
    longDescription = ''
      directories is an OCaml library that provides configuration, cache and
      data paths (and more!) following the suitable conventions on Linux, macOS
      and Windows. It is inspired by similar libraries for other languages such
      as directories-jvm.

      The following conventions are used: XDG Base Directory Specification and
      xdg-user-dirs on Linux, Known Folders on Windows, Standard Directories on
      macOS.
    '';
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ bcc32 ];
  };
}
