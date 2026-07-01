{
  lib,
  stdenv,
  apple-sdk,
}:

{
  # macOS: remove hardcoded include paths used upstream
  OSX = lib.optionalAttrs (stdenv.hostPlatform.isDarwin) {
    prefix = "${apple-sdk.sdkroot}";
    includes = [ ];
  };

  # backports from 7.9, remove after bumping version
  exclude_namespaces = [
    "std"
    "opencascade"
    "IMeshData"
    "IVtkTools"
    "BVH"
    "OpenGl"
    "OpenGl_HashMapInitializer"
    "Graphic3d_TransformUtils"
  ];

  byref_types_smart_ptr = [
    "opencascade::handle"
    "handle"
    "Handle"
  ];

  Modules = {
    Standard.exclude_methods = [
      "Standard_Dump::DumpCharacterValues"
      "Standard_Dump::DumpRealValues"
      "Standard_CLocaleSentry::GetCLocale"
      "Standard_Dump::InitRealValues"
      "Standard_ErrorHandler::Label"
    ];

    NCollection.exclude_class_template_methods = [
      ".*::begin"
      ".*::end"
      ".*::cbegin"
      ".*::cend"
    ];

    AdvApp2Var.exclude_classes = [ "AdvApp2Var_MathBase" ];
  };
}
