{
  lib,
  stdenv,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  fonttools,
  lxml,
  matplotlib,
  pandas,
  pillow,
  python-barcode,
  qrcode,
  segno,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "borb";
  version = "3.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "borb-pdf";
    repo = "borb";
    tag = "v${version}";
    hash = "sha256-p9tVG2Pvqk5uDXdeB+7F71w3h4/zut+htlm4p+qqfWA=";
  };

  # ModuleNotFoundError: No module named '_decimal'
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    grep -Rl 'from _decimal' tests/ | while read -r test_file; do
      substituteInPlace "$test_file" \
        --replace-fail 'from _decimal' 'from decimal'
    done
  '';

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    fonttools
    lxml
    pillow
    python-barcode
    qrcode
    requests
    setuptools
  ];

  nativeCheckInputs = [
    matplotlib
    pandas
    pytestCheckHook
    segno
  ];

  pythonImportsCheck = [ "borb.pdf" ];

  disabledTests = [
    "test_code_files_are_small"
    "test_image_has_pdfobject_methods"
    # Tests require network access
    "test_abc_ordered_list_of_images"
    "test_ordered_list_of_images"
    "test_roman_numeral_ordered_list_of_images"
    "test_unordered_list_of_images"
    "test_fixed_column_width_table_of_images"
    "test_flexible_column_width_table_of_images"
    "test_single_column_layout_of_images"
    "test_two_column_layout_of_images"
    # Reads a corpus from the upstream author's home directory
    "test_read_corpus"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/pdf_tests/document_layout_tests/test_a4_portrait_invoice.py"
    "tests/pdf_tests/document_layout_tests/test_a4_portrait_resume.py"
    "tests/pdf_tests/document_layout_tests/test_slideshow.py"
    "tests/pdf_tests/layout_element_tests/image_tests/test_image.py"
    "tests/pdf_tests/layout_element_tests/image_tests/test_image_alignment.py"
    "tests/pdf_tests/layout_element_tests/image_tests/test_image_background.py"
    "tests/pdf_tests/layout_element_tests/image_tests/test_image_padding.py"
    "tests/pdf_tests/layout_element_tests/image_tests/test_screenshot.py"
    "tests/pdf_tests/layout_element_tests/image_tests/test_unsplash*.py"
    "tests/pdf_tests/layout_element_tests/smart_art_tests/test_*_picture_list*.py"
    "tests/pdf_tests/layout_element_tests/smart_art_tests/test_smart_art_overview.py"
    "tests/pdf_tests/toolkit_tests/test_get_color.py"
    "tests/pdf_tests/toolkit_tests/test_get_document_as_graphml.py"
    "tests/pdf_tests/toolkit_tests/test_get_images.py"
    "tests/pdf_tests/toolkit_tests/test_get_text.py"
    # Require API keys from tests/secrets.py, which is not distributed
    "tests/pdf_tests/font_tests/true_type_font_tests/test_font_name_with_special_characters.py"
    "tests/pdf_tests/font_tests/true_type_font_tests/test_google_true_type_font.py"
    "tests/pdf_tests/layout_element_tests/table_tests/test_grocery_list.py"
    "tests/pdf_tests/visitor_tests/test_conformance.py"
    # Require files from the upstream author's home directory
    "tests/pdf_tests/license_tests/test_license.py"
    "tests/pdf_tests/toolkit_tests/test_draw_bounding_boxes.py"
    "tests/pdf_tests/toolkit_tests/test_get_keywords_by_pagewise_tf_idf_from_corpus.py"
    "tests/pdf_tests/visitor_tests/test_open_corpus.py"
    # Require optional dependencies that are not packaged
    "tests/pdf_tests/document_layout_tests/test_a4_portrait.py"
    "tests/pdf_tests/layout_element_tests/annotation_tests/test_sound_annotation.py"
    "tests/pdf_tests/layout_element_tests/image_tests/test_avatar*.py"
    # Require an X server
    "tests/pdf_tests/layout_element_tests/image_tests/test_screenshot_*.py"
    # Timing-sensitive
    "tests/pdf_tests/layout_element_tests/text_tests/test_*_speed.py"
    "tests/pdf_tests/lipsum_tests/test_lipsum_speed.py"
  ];

  meta = {
    description = "Library for reading, creating and manipulating PDF files in Python";
    homepage = "https://borbpdf.com/";
    changelog = "https://github.com/borb-pdf/borb/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
  };
}
