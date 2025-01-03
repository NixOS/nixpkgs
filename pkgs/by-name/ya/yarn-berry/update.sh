#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl jq

set -eou pipefail

payload=$(jq -cn --rawfile query /dev/stdin '{"query": $query}' <<EOF | curl -s -H "Authorization: bearer $GITHUB_TOKEN" -d '@-' https://api.github.com/graphql
{
  repository(owner: "yarnpkg", name: "berry") {
    tag: refs(refPrefix: "refs/tags/@yarnpkg/cli/", first: 50, orderBy: {field: TAG_COMMIT_DATE, direction: DESC}) {
      nodes {
        name
      }
    }
  }
}
EOF
)

version=$(jq -r "[.data.repository.tag.nodes[].name | select(contains(\"-\")|not)] | max_by(split(\".\") | map(tonumber))" <<< "$payload")

update-source-version yarn-berry "$version"
