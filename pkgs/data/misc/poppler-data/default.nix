{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "poppler-data-0.2.1";

  src = fetchurl {
    url = "http://poppler.freedesktop.org/${name}.tar.gz";
    sha256 = "0q56l5v89pnpkm1kqmwb1sx2zcx89q6bxz2hq2cpkq5f8kgvl3c9";
  };

  installFlags = "prefix=\${out}";
  config_tool_name = "poppler-data-dir";
  config_tool = ./poppler-data-dir;
  postInstall = "
  ensureDir \${out}/bin
  substituteAll ${config_tool} \${out}/bin/${config_tool_name}
  chmod +x \${out}/bin/${config_tool_name}
  ";

  meta = {
    homepage = http://poppler.freedesktop.org/;
    description = "Encoding files for Poppler, a PDF rendering library";
  };
}
