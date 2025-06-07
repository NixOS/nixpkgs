{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  fpath,
}:

buildDunePackage rec {
  pname = "directories";
  version = "0.6";
  useDune2 = true;

  minimalOCamlVersion = "4.07";

  src = fetchFromGitHub {
    owner = "ocamlpro";
    repo = pname;
    rev = version;
    sha256 = "sha256-c/9ChiSODD1K7YsMj65tjErAwXeWvEQ8BkAcUvsr19c=";
  };

  propagatedBuildInputs = [
    fpath
  ];

  meta = {
    homepage = "https://github.com/ocamlpro/directories";
    description = "OCaml library that provides configuration, cache and data paths (and more!) following the suitable conventions on Linux, macOS and Windows";
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
