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

buildPythonPackage rec {
  pname = "md2pdf";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmaupetit";
    repo = "md2pdf";
    tag = "v${version}";
    hash = "sha256-ksccl9K0o0mZleyLe1K1ob78W2MKZksTFtu6/dZUWeg=";
  };

  build-system = [ hatchling ];

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
  ++ lib.concatAttrValues optional-dependencies;

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
    changelog = "https://github.com/jmaupetit/md2pdf/blob/${src.tag}/CHANGELOG.md";
    description = "Markdown to PDF conversion tool";
    homepage = "https://github.com/jmaupetit/md2pdf";
    license = lib.licenses.mit;
    mainProgram = "md2pdf";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
