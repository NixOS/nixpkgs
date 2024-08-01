{ callPackage
, enableJavaFX ? false
, ...
}@args:

callPackage ./common.nix ({
  # Details from https://www.azul.com/downloads/?version=java-22-lts&package=jdk
  # Note that the latest build may differ by platform
  dists = {
    x86_64-linux = {
      zuluVersion = "22.28.91";
      jdkVersion = "22.0.0";
      hash =
        if enableJavaFX then "sha256-+qUrZ+GlspSP3RLTAbgEtFm0B0fzX/VD1WUl6mk2c/0="
        else "sha256-HvMiODsz+puu1xtxG2RRXH/PWCk91PGNZ7UcOd9orqQ=";
    };

    aarch64-linux = {
      zuluVersion = "22.28.91";
      jdkVersion = "22.0.0";
      hash =
        if enableJavaFX then throw "JavaFX is not available for aarch64-linux"
        else "sha256-3RLNNEbMk5wAZsQmbQj/jpx9iTL/yr9N3wL4t7m6c+s=";
    };

    x86_64-darwin = {
      zuluVersion = "22.28.91";
      jdkVersion = "22.0.0";
      hash =
        if enableJavaFX then "sha256-QkFwbc2YFEWb5rddhH4a+zmtsrXxUBSuS8yg9qUb728="
        else "sha256-Y6PSNQjHRXukwux2sVbvpTIqT+Cg+KeG1C0iSEwyKZw=";
    };

    aarch64-darwin = {
      zuluVersion = "22.28.91";
      jdkVersion = "22.0.0";
      hash =
        if enableJavaFX then "sha256-256UP6MtUReQYqCKVt0ThN9BVDyKLAMXQTdpcDB9t24="
        else "sha256-o0VkWB4+PzBmNNWy+FZlyjTgukBTe6owfydb3YNfEE0=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" ])
