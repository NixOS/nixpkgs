{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tidy-viewer";
  version = "1.8.93";

  src = fetchFromGitHub {
    owner = "alexhallam";
    repo = "tv";
    tag = finalAttrs.version;
    sha256 = "sha256-wiVcdTnjEFh5kSyxmK+ab0LkEAbQaygmLdrFfM12DyM=";
  };

  cargoHash = "sha256-HF7M4s2OHCAyVkbCIBxGButAxbxrhjmY3YE/do8et1s=";

  # this test parses command line arguments
  # error: Found argument '--test-threads' which wasn't expected, or isn't valid in this context
  checkFlags = [
    "--skip=build_reader_can_create_reader_without_file_specified"
  ];

  meta = {
    changelog = "https://github.com/alexhallam/tv/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Cross-platform CLI csv pretty printer that uses column styling to maximize viewer enjoyment";
    homepage = "https://github.com/alexhallam/tv";
    license = lib.licenses.unlicense;
    mainProgram = "tidy-viewer";
    maintainers = with lib.maintainers; [ phanirithvij ];
  };
})
