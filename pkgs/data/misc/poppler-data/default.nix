args: with args;

stdenv.mkDerivation rec {
  name = "poppler-data-0.1.1";

  src = fetchurl {
	url = http://poppler.freedesktop.org/poppler-data-0.1.1.tar.gz;
    sha256 = "1hnfanqbhkjyjq0j8yfadgbcai9mggz09lzxnia2bbk4lhy9722a";
  };

  installFlags = "prefix=\${out}";
  config_tool_name = "poppler-data-dir";
  config_tool = ./poppler-data-dir;
  postInstall = "
  ensureDir \${out}/bin
  substituteAll ${config_tool} \${out}/bin/${config_tool_name}
  chmod +x \${out}/bin/${config_tool_name}
  ";
}
