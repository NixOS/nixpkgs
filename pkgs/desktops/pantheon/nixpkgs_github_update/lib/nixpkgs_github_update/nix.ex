defmodule NixpkgsGitHubUpdate.Nix do
  def executable do
    nix = System.find_executable("nix")

    if nil === nix do
      raise RuntimeError, message: "missing executable for 'nix'"
    end

    nix
  end

  def eval!(attribute) do
    System.cmd(
      executable(),
      [
        "eval",
        "--json",
        attribute
      ],
      stderr_to_stdout: true
    )
    |> handle_eval
  end

  def handle_eval({eval_result, 0}) do
    case eval_result do
      "" -> eval_result
      _ -> Poison.Parser.parse!(eval_result, %{})
    end
  end

  def handle_eval({eval_result, _}) do
    IO.puts("Error running nix eval: #{eval_result}")
  end

  def attribute_exists?(attribute) do
    eval!("(with import <nixpkgs> {}; lib.isDerivation #{attribute})")
  end

  def update_source_version(attribute, version) do
    System.cmd("update-source-version", [
      attribute,
      version
    ])
  end

  def get_url_attr(attribute) do
    case eval!("nixpkgs.#{attribute}.src.fetchSubmodules") do
      true -> "url"
      _ -> "urls"
    end
  end

  def get_owner_repo(attribute) do
    url_attr = get_url_attr(attribute)

    eval!("nixpkgs.#{attribute}.src.#{url_attr}")
    |> case do
      # It's fetchFromGitHub if we got a list
      [url | _] ->
        URI.parse(url).path
        |> String.split("/archive", trim: true)
        |> List.first()
        |> String.split("/", trim: true)

      # It's fetchgit if we got a plain string
      url ->
        URI.parse(url).path
        |> String.split(".git", trim: true)
        |> List.first()
        |> String.split("/", trim: true)
    end
    |> List.to_tuple()
  end
end
