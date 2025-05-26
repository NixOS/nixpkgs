#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts jq

set -euo pipefail

declare -ar packages=(
    langchain
    langchain-anthropic
    langchain-azure-dynamic-sessions
    langchain-chroma
    langchain-community
    langchain-core
    langchain-deepseek
    langchain-fireworks
    langchain-groq
    langchain-huggingface
    langchain-mistralai
    langchain-mongodb
    langchain-ollama
    langchain-openai
    langchain-perplexity
    langchain-tests
    langchain-text-splitters
    langchain-xai
)

tags=$(git ls-remote --tags --refs "https://github.com/langchain-ai/langchain" | cut --delimiter=/ --field=3-)

# Will be printed as JSON at the end to list what  needs updating
updates=""

for package in ${packages[@]}
do
    pyPackage="python3Packages.$package"
    oldVersion="$(nix-instantiate --eval -E "with import ./. {}; lib.getVersion $pyPackage" | tr -d '"')"
    newVersion=$(echo "$tags" | grep -Po "(?<=$package==)\d+\.\d+\.\d+$" | sort --version-sort --reverse | head -1 )
    if [[ "$newVersion" != "$oldVersion" ]]; then
        update-source-version $pyPackage "$newVersion"
        updates+="{
    \"attrPath\": \"$pyPackage\",
    \"oldVersion\": \"$oldVersion\",
    \"newVersion\": \"$newVersion\",
    \"files\": [
        \"$PWD/pkgs/development/python-modules/${package}/default.nix\"
    ]
},"
    fi
done
# Remove trailing comma
updates=${updates%,}
# Print the updates in JSON format
echo "[ $updates ]"
