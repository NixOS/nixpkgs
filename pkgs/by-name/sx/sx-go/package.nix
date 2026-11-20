{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "sx-go";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "v-byte-cpu";
    repo = "sx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1KG1NKDzznKvXdfNcwkh0sfU4J7i+UTCn6H4HdlQUms=";
  };

  vendorHash = "sha256-gGMdPvoUaYHTAvFlUZHjinpB6xYxvXmVZv0q+IhN00M=";

  buildInputs = [ libpcap ];

  postFixup = ''
    # Rename binary to avoid conflict with sx
    mv $out/bin/sx $out/bin/${finalAttrs.pname}
  '';

  meta = {
    description = "Command-line network scanner";
    homepage = "https://github.com/v-byte-cpu/sx";
    changelog = "https://github.com/v-byte-cpu/sx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sx-go";
  };
})
