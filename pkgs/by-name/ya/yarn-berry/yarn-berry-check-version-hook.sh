yarnBerryCheckVersionHook() {
  if [[ -z "$yarnBerryCheckVersionHookPackageJson" ]]; then
    yarnBerryCheckVersionHookPackageJson="package.json"
  fi

  YARN_VERSION="@yarnVersion@"
  PACKAGE_MANAGER=$(@jq@ -r .packageManager $yarnBerryCheckVersionHookPackageJson)
  echo "Yarn version is $YARN_VERSION"
  echo "Package manager in package.json is $PACKAGE_MANAGER"

  if [[ "$PACKAGE_MANAGER" != "yarn@$YARN_VERSION" ]]; then
    echo "The value for package manager in package.json doesn't match the version of Yarn that has been provided in this builder"
    exit 1
  fi
}

preConfigureHooks+=(yarnBerryCheckVersionHook)
