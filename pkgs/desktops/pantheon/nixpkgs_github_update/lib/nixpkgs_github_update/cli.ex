defmodule NixpkgsGitHubUpdate.CLI do
  @moduledoc """
  Run updates on Nix Expressions that use fetchFromGitHub.

  Arguments the script accepts:
  --attribute <attribute_path>

  Example usage:
  ```
  ./nixpkgs_github_update --attribute "notes-up"
  ```
  """
  alias NixpkgsGitHubUpdate.{Nix, GitHubLatestVersion}

  def help do
    IO.puts("""
    Run updates on Nix Expressions that use fetchFromGitHub.

    Arguments the script accepts:
    --attribute <attribute_path>

    Example usage:
    ./nixpkgs_github_update --attribute "notes-up"
    """)
  end

  def main([]) do
    help()
  end

  def main(args) do
    opts = parse_args(args)

    attribute = opts[:attribute]

    case Nix.attribute_exists?(attribute) do
      true -> update(attribute)
      _ -> exit("Requested attribute doesn't exist.")
    end
  end

  def parse_args(args) do
    {options, _, _} =
      args
      |> OptionParser.parse(strict: [attribute: :string])

    options
  end

  def update(attribute) do
    version =
      Nix.get_owner_repo(attribute)
      |> GitHubLatestVersion.fetch()
      |> decode_response()
      |> construct_version()

    Nix.update_source_version(attribute, version)
  end

  def decode_response({:ok, response}), do: response

  def decode_response({:error, error}) do
    IO.puts("Error getting latest release from GitHub: #{error["message"]}")
    System.halt(2)
  end

  def construct_version(response) do
    Map.get(response, "tag_name")
    |> String.trim_leading("v")
  end
end
