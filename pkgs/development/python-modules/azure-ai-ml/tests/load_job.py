"""Offline test: build command jobs from YAML and from code."""

import sys

from azure.ai.ml import command, load_job
from azure.ai.ml.entities import Command

job = load_job(sys.argv[1])
assert isinstance(job, Command), type(job)
assert job.command == "echo hello ${{inputs.n}}", job.command
assert job.experiment_name == "smoke", job.experiment_name
assert job.compute == "cpu-cluster", job.compute
assert "n" in job.inputs, job.inputs

built = command(
    command="echo hi",
    environment="azureml:env@latest",
    compute="cpu",
)
assert isinstance(built, Command), type(built)
assert built.command == "echo hi", built.command
