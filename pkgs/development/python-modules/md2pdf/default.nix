{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jinja2,
  lib,
  markdown,
  pygments,
  pymdown-extensions,
  pypdf,
  pytest-cov-stub,
  pytestCheckHook,
  python-frontmatter,
  typer,
  watchfiles,
  weasyprint,
}:

buildPythonPackage (finalAttrs: {
  pname = "md2pdf";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmaupetit";
    repo = "md2pdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q6RZ1eKKhraDJnOqRuK9fCSIIRxeFYZKecGx+ehbziU=";
  };

  postPatch = ''
    substituteInPlace tests/test_cli.py \
      --replace-fail "': path '" "': Path '"
  '';

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "weasyprint"
  ];

  dependencies = [
    jinja2
    markdown
    pygments
    pymdown-extensions
    python-frontmatter
    weasyprint
  ];

  optional-dependencies = {
    cli = [
      typer
      watchfiles
    ];
    latex = [
      # FIXME package markdown-latex
    ];
  };

  pythonImportsCheck = [ "md2pdf" ];

  nativeCheckInputs = [
    pypdf
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  disabledTests = [
    # AssertionError caused by
    #     glyph rendered for Unicode string unsupported by fonts: "👋" (U+1F44B)
    "test_generate_pdf_with_jinja_context_input"
    "test_generate_pdf_with_jinja_frontmatter_and_context_input"
    "test_generate_pdf_with_jinja_frontmatter_input"
  ];

  meta = {
    changelog = "https://github.com/jmaupetit/md2pdf/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Markdown to PDF conversion tool";
    homepage = "https://github.com/jmaupetit/md2pdf";
    license = lib.licenses.mit;
    mainProgram = "md2pdf";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
