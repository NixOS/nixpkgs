{ fetchurl, stdenv }:

stdenv.mkDerivation rec {
  name = "poppler-data-0.2.0";

  src = fetchurl {
    url = "http://poppler.freedesktop.org/${name}.tar.gz";
    sha256 = "0cpa1krpd6xjbn1nv825z5p8v4cfcypdri4bhzvn2dnjy997x9k8";
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
